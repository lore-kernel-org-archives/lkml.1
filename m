Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbZCPNDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbZCPNDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZCPNDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:03:06 -0400
Received: from mail.suse.de ([195.135.220.2]:36037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZCPNDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:03:04 -0400
Message-ID: <49BE4E00.9000505@suse.de>
Date: Mon, 16 Mar 2009 14:02:56 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>,
       LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Subject: Re: 2.6.29-rc breaks STD using Intel 945
References: <200903042020.57671.eike-kernel@sf-tec.de> <20090305125529.GB16693@silver.sucs.org> <200903081902.23998.eike-kernel@sf-tec.de> <20090314133704.GA21948@silver.sucs.org>
In-Reply-To: <20090314133704.GA21948@silver.sucs.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Hmm. Does switching to and then back from a virtual terminal also break?

I think i have the same problem and yes, switching to and back from vt
also breaks X.
I opened a bug here: https://bugzilla.novell.com/show_bug.cgi?id=485537

For me it currently helps to disable dri which makes my system stable
again.

Thanks,
Frank

