Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYJ0JWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYJ0JWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYJ0JWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:22:12 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:50956 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbYJ0JWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:22:11 -0400
Date: Mon, 27 Oct 2008 10:22:08 +0100
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081027092208.GC16491@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org> <48F308E8.4030503@kernel.org> <20081013142951.GB23124@anita.doom> <48F58A96.8040406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F58A96.8040406@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun!

After my short reply I had a 2.6.27 running with

[-- Attachment #2: sata_nv-nf2-hrst-debug-take2.patch --]

fine so far. It bootet immediately at any time I powercycled the
machine. Hot, cold and reboot seems to be no problem, no
/var/log/messages flooding also.

I just wanted to inform you, whatever the investigations result into, on
_my_ machine this incarnation is just fine.

Regards, Konsti



-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
