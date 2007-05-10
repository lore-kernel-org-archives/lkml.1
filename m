Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbXEJU7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbXEJU7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbXEJU6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:58:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:36167 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbXEJU6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EffZ9VLfXWiqGKLRgjS2KGd2fh3x3B2vRED8K29Gnjy+zQWGGVVp8S2kmCyZ15+WgJTwG6i9E/jOD5vAZLyK80U71Bvh870ka/e6/eApmE1A2hXIwSf1xwro5KklEP/cFuOW3d2BscOYZOaOfUqKmR/nEx+ozdHI0+/E1IDVW/Q=
Message-ID: <a781481a0705101358s7f5c953cx52ce883524d28852@mail.gmail.com>
Date: Fri, 11 May 2007 02:28:53 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Chris Wedgwood" <cw@f00f.org>
Subject: Re: [RFC] nfs: memclear_highpage_flush -> zero_user_page conversion
Cc: LKML <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       trond.myklebust@fys.uio.no
In-Reply-To: <20070510191811.GA17220@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510191811.GA17220@tuatara.stupidest.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, Chris Wedgwood <cw@f00f.org> wrote:
> Does this look correct?

These conversions seem to be present in 21-mm2 already.
