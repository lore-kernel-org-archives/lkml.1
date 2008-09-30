Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYI3Mvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYI3Mvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYI3Mvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:51:36 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:40940 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYI3Mvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FNgwCOZ92YRRNJ9xgMyvw0C+7+iDrrd2ClgnPocOYFpPBirbMXbCDyoubsMnxFb9MD
         M081XfS1SmyFrgmPD3K436UK1c9DCrA/N1xvUORsWDuyvx6SG8KebDHJ1fc1Ii7A2hxO
         qJaM1Ro5eTrvcVEtiMRf1N4dY2SExFE/7APuA=
Message-ID: <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
Date: Tue, 30 Sep 2008 08:51:34 -0400
From: "Monty Montgomery" <monty@xiph.org>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
	 <1214605634.3394.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
	 <1214841102.3381.5.camel@localhost.localdomain>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
	 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
	 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
	 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
X-Google-Sender-Auth: 68e09c552aad3009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed in SVN; pull a copy and try again.

[Mein Gott, that bug was just embarrassing]

Monty
