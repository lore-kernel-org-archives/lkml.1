Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYI1H1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYI1H1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 03:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYI1H10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 03:27:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:63323 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYI1H10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 03:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=olu5zsWzedXo+2cEKVmk9l8icnabYNar/9hsym5b8l5Vayx+mAZamCXjmbx+PmTPt/
         MXBlYg1r1+l/dn6n0KVS0vQP4VHBqj8Azs6EPfnj24EfLsdxvHKe1Zv5wXjrNYRh40H2
         xCcU0MgchxATvDCVJO0jSXoo29KsNANbI8VlE=
Message-ID: <86802c440809280027t737af480p9565a003d12d2dc6@mail.gmail.com>
Date: Sun, 28 Sep 2008 00:27:25 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "D. Hugh Redelmeier" <hugh@mimosa.com>
Subject: Re: questions about x86: mtrr cleanup for converting continuous to discrete layout
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0809272343020.20325@redclaw.mimosa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LRH.2.00.0809272343020.20325@redclaw.mimosa.com>
X-Google-Sender-Auth: f7b415197aa67f46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 10:10 PM, D. Hugh Redelmeier <hugh@mimosa.com> wrote:
> [I have a userland program to attack the same problem.  See
>  ftp://ftp.cs.utoronto.ca/pub/hugh/mtrr-uncover-2008sept27.tgz
> When I make changes, the date portion of the name changes -- it is a
> work in progress.]

it should be good for even old kernel without workaround in kernel.

YH
