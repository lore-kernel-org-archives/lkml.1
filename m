Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYGKTkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYGKTkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYGKTj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:39:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:52230 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYGKTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GJEUyCnVYrHnu2S0ZMqa2Rpl8o+uviO06n63nZeHPK/6OBIHSmGWD1Tuo7UR8bwcQP
         34ffIUnZCbbXuEePn4zIBAO0bmlAil6SMpJFS4Cuby9peOUVhSDiORuIKc/tyYRXTX4D
         2QF9n/0aow9JOdyc4npM3/tUKRLUe/QTVf/kY=
Message-ID: <ea8d860a0807111239u2d8318d0k74312f6b74ebc06a@mail.gmail.com>
Date: Fri, 11 Jul 2008 21:39:52 +0200
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: Valdis.Kletnieks@vt.edu
Subject: Re: patch tpm-correct-tpm-timeouts-to-jiffies-conversion.patch breaks stuff
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Marcel Selhorst" <tpm@selhorst.net>,
       "Kylene Jo Hall" <kjhall@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <18107.1215803534@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18107.1215803534@turing-police.cc.vt.edu>
X-Google-Sender-Auth: e49ce3a2adf6992a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/11  <Valdis.Kletnieks@vt.edu>:

>
> So is the spec wrong, or is my chipset on drugs, or?
>
Can you provide configuration information?
- used TPM chip
- used TPM kernel modules

Regards
Marcin Obara
