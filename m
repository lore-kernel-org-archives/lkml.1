Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYCNN37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYCNN37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYCNN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:29:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:9899 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbYCNN3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qPrNJHCxcVqpzErjVN80aT/rd5mVObTvosrXnVBRy/gn2ljZuPJcRDEI07Q9IeJPzFnK+DskJF2i2QdQRQLyrDkVt4osMIiBX1RpcrM2G4/v5rEt2TrZJhsn3x3Rw/1TvQFA4l6ayWS+CZBaO629fwp4YPUjT/ToOx99Fq5WBEY=
Message-ID: <983191750803140629v5a595ecfo39c75b34134d549a@mail.gmail.com>
Date: Fri, 14 Mar 2008 18:59:01 +0530
From: "Shard Gupta" <shard.kgp@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: netfilter and iptables help needed
In-Reply-To: <983191750803140618p354fc09fl7493f6196d965641@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <983191750803140618p354fc09fl7493f6196d965641@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

I am working on Potables and its related kernel modules. I was stuck
in searching the entries (especially rules) present in the IPTables.
Kindly, help me view all the rules located in the IPTables either on
the disk, or if I can view them through a specific function. What are
the functions that are involved in creation, deletion and updating of
these rules in the IPTables.
If I have to change the algorithm logic for packet classification in
IPTables, then please specify the specific functions for this.

- Shard Gupta
