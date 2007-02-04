Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbXBDTdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbXBDTdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXBDTdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:33:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:48378 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXBDTdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:33:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DcOIvJudx9GWqYMb+4JRWXA5uNPo4dGL8Fk+3sj0WXp83/+akrN38ZbIAdgIByKPMMA/WCxh76V35b1lyLF7xIa6AivgnWEMxqDvjJkBmjaLwkLiqZfJz8sjqUaKF6lnyKMAe1WNK+cmMle2u91u5SJg1ntY90gsYjBnSME7RBY=
Message-ID: <8d158e1f0702041133w4d351ac7y18d08c49745e4c7b@mail.gmail.com>
Date: Sun, 4 Feb 2007 20:33:39 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: More pata_ stuff
Cc: "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	 <45C619FC.3040804@shaw.ca>
	 <8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	 <200702041910.46421.s0348365@sms.ed.ac.uk>
	 <20070204193441.6746bbca@localhost.localdomain>
	 <8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Patrick Ale <patrick.ale@gmail.com> wrote:
Ammmmmm,

not to sound like a wise guy but... CONFIG_ATA_PIIX is the SATA
driver, not the PATA driver.. atleast that is what menuconfig tells me
when I select "Help" when I look at the config options
