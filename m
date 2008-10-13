Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYJMO0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYJMO0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbYJMOZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:25:48 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:43617 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754763AbYJMOZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:25:47 -0400
Date: Mon, 13 Oct 2008 16:25:42 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081013142542.GA23124@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48E8947A.5020608@kernel.org> <48E89839.5030307@panasas.com> <48E899F9.9040206@kernel.org> <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F3088C.9010002@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-10-13 17:36 +0900 schrieb Tejun Heo:

> It has all the fans for a reason.  :-)

:-)

> Eh... Joke aside.  I still don't know what's going on here.  Before
> 2.6.26, you always had clean boot, right?

Yes, with 2.6.25 it always had a clean booting system.

>From time to time I do an update and with some 2.6.26_rcX I had
problems the system not solving a cold boot sometimes. Long I suspected
a hardware issue but one time I went down to 2.6.25 and the problem was
away. 

Then I updated to 2.6.27_rcX because I was hunting down some nfsv4
error, considering this as a bug or an issue in front of screen. Then I
realised the cold boot problem again which I almost forgot meanwhile or
considered closed from 2.6.26_rcX over 2.6.26 to 2.6.27_rcX.

Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
