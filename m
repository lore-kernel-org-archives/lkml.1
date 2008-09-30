Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYI3Rc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYI3Rc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYI3RcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:32:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:52957 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYI3RcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xYDPM2HLYjo1p2PNKK9sm7MWPMRROVJpjsiDtS5V5GnvkhWjRAYACsj7g8EAkm8Zzj
         jrbi930n268WVSrPYM77z4A2Ev4yweT/SxziS0wxlx324swfalh7z3q49zJuYTS+J33J
         mV4MEg3tr3r9FNc/y0LvXWRFUGROLk2AavjQc=
Message-ID: <806dafc20809301032n559832et45f3bf5e3f7c495c@mail.gmail.com>
Date: Tue, 30 Sep 2008 13:32:15 -0400
From: "Monty Montgomery" <monty@xiph.org>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
	 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
	 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
	 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
	 <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
	 <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
	 <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com>
	 <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
X-Google-Sender-Auth: 45ec00ca0dbffead
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 11:21 AM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:

>> (May I ask-- why the hard starting/stopping of the interface?  Power saving?]
>
> Which hard starting/stopping do you mean?

why the calls to sg_start?

Monty
