Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbYD2TKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbYD2TKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760504AbYD2TJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:09:43 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:5657 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759667AbYD2TJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OAioMjZasLhTl6ErrfcJ5us/8ptYHEfL9WfMTETfGgcIpl1RYG+s5KNXo+dzTUmoXuPPUA659m+o3c2Cri+n4cxEHF9hsm+d1E6IsWCRHj5c9SPEI1xAHlmJTdEeWYfGjkLI3ignkx/76cTAUIXdv0ix6lMisfzjI9x9RcooryQ=
Message-ID: <7b9198260804291209t45640430x3af9a130950766fc@mail.gmail.com>
Date: Tue, 29 Apr 2008 20:09:40 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jason Baron" <jbaron@redhat.com>
Subject: Re: [patch 1/3] dynamic_printk: core
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080429184143.GB8717@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429184143.GB8717@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/29 Jason Baron <jbaron@redhat.com>:
> [...]
>  +         The impact of this compile option is a larger kerenl text size ~1%.
> [...]

Hi,

Just noticed the typo above!

-- 
Regards,
Tom Spink
University of Edinburgh
