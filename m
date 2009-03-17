Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbZCQI2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbZCQI2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbZCQI1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:27:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:13269 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761232AbZCQI1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jW4HGvxrdyX1j7lxs9aK3YEXxwe9E0cHA8+5Www/2q8w1+1FuesAHK9B8zpOon/4Yk
         vlb91kSDlvkmXxT5xWVq9av3HANGc7aJfN7WhkTGaChnb2Zxnzen3EONTO/+8rOf5ZIT
         +59cR0oKhu0Zk2RLy9ART3O+yDkhJ2oDKHogg=
MIME-Version: 1.0
In-Reply-To: <20090317082549.GA5127@orion>
References: <20090317082549.GA5127@orion>
Date: Tue, 17 Mar 2009 11:27:49 +0300
Message-ID: <a4423d670903170127gb874569x544115958be1e7db@mail.gmail.com>
Subject: Re: [PATCH next] slob: fix build problem
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/17 Alexander Beregalov <a.beregalov@gmail.com>:
> mm/slob.c: In function '__kmalloc_node':
> mm/slob.c:480: error: 'flags' undeclared (first use in this function)

Oh, I see yesterday discussion, sorry.
