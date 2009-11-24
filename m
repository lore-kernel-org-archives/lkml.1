Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbZKXCFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbZKXCFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZKXCFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:05:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:59579 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbZKXCFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=X9RlnROXlXMIWeEEU+FJFbrlKNzafiQxHjZ07X6/DkFjVYqgCqj9WpDaJHB9E+BDC7
         cHiJmpluVTOlbqkuBItgwTc0ZPJvHyx0YdHjgex2KPA5aGTbCylbqWqXBBM06EkTb0Pd
         B0oxTEutgaaw+GcHZDg7LQPwrxLz/8Wnk4T7I=
MIME-Version: 1.0
In-Reply-To: <4B0B3E5F.4060102@gmail.com>
References: <525c5a6c0911231620u6d23810fu9fed3605617fe421@mail.gmail.com>
	 <200911240137.39266.rjw@sisk.pl> <4B0B3E5F.4060102@gmail.com>
Date: Mon, 23 Nov 2009 21:05:48 -0500
Message-ID: <525c5a6c0911231805k1c567e90q6129b5616db337b2@mail.gmail.com>
Subject: Re: Toshiba Satellite ACPI problems
From: Mike Smith <scgtrp@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, that looks really unhappy..
Hence this thread :)

> Can you extract and post the DSDT in either raw or decompiled form, as
> described here:
Someone on Bugzilla asked for something similar; I posted the acpidump
output there.

(It occurs to me that I only sent that link to Rafael instead of the
list, so: http://bugzilla.kernel.org/show_bug.cgi?id=14679)
