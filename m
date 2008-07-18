Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYGRKv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYGRKv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYGRKvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:51:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:28231 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYGRKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Dyj74hoUcscclygbVg3XDAp7mqXoN0f57C+G9TgmPld/5mpqZDxEkgTBcEcjAQQbE5
         ZM9874hxnnzogiB3JXhCwbYRXhXyic5KAJYnSfqs8moMKIoePbUpnz8asHFxXcoL5dkT
         bnHp8QzYv9I2i8ULbbOXnfNTvt6jTTU0SpRi0=
Message-ID: <ea8d860a0807180351q490deea1rdf61469057e79ac3@mail.gmail.com>
Date: Fri, 18 Jul 2008 12:51:48 +0200
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Intel Management Engine Interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <874p6nsft5.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
	 <874p6nsft5.fsf@basil.nowhere.org>
X-Google-Sender-Auth: d792d7b8674d4df9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/18 Andi Kleen <andi@firstfloor.org>:
> How about the save oops data in HECI code? Will that be posted
> on top of this?

This question was mostly already answered in
http://lkml.org/lkml/2007/12/11/166
In addition current MEI driver is for current platforms (AMT 3, 4, 5)
and have no AMT 1.0 legacy support.

Marcin
