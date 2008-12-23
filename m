Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbYLWQqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbYLWQqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYLWQpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:45:51 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61853 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYLWQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:45:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tJ4Ar8ZxsBwC8STIIH5JSLaVqz8wBrTHRYmYvrV2r6sj/nhvD0/LvB8m+F8oev6dZS
         PzCfYjwll2JaQB0zdtYJZU2uK4VVSWDrzh+Yvo6LHS4iewF+GPu4DFRd1UO1dtLkexlN
         C4iL9SwOlwBEwhIGdK/UAZe8jW/aJCAQA4H58=
Message-ID: <3b5e77ad0812230845w3178e803u416ecf1f68a64725@mail.gmail.com>
Date: Tue, 23 Dec 2008 18:45:48 +0200
From: "Ron Livne" <ronli.voltaire@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.29
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
In-Reply-To: <adaocz2x5xp.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aday6y7x2yr.fsf@cisco.com>
	 <3b5e77ad0812222354y5d4effe8xc6750d6620e20c75@mail.gmail.com>
	 <adaocz2x5xp.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know it was stuck there,
that's why I've sent a new version that doesn't rely on it.
I've implemented the more_ops (in libibvers) in my patches - that's
the only thing I needed from XRC.

Ron


On Tue, Dec 23, 2008 at 5:33 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  > Any chance create_qp_flags will get in?
>
>  Nope, since that's stuck behind XRC.
>
