Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbYCYVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbYCYVqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762085AbYCYVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:42:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:37304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762080AbYCYVm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z637Qo3Y01uI5IWmQJD0DPYnyLJF0XBxfqbaaOOl+1I0EQc60NTpn5Oe+FwG5d0sZRyrFG3wNqhawvuUzz6duIm1+Zmse2a5Wr4YK0qeoAzTU9SzahdSqEzPulNYubbzsHccJB2CvultiBeK0lXGl9s/7MVwpbEqzY61+fuqC20=
Message-ID: <6101e8c40803251442j471a086ew774cfa7c4f15b3d0@mail.gmail.com>
Date: Tue, 25 Mar 2008 22:42:55 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] list_add corruption in slab.c
Cc: "Daniel Yeisley" <dan.yeisley@unisys.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, "Christoph Lameter" <clameter@sgi.com>, mel@csn.ul.ie
In-Reply-To: <84144f020803251438j4896d587j917fece9421a1222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206464258.13473.11.camel@localhost.localdomain>
	 <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com>
	 <1206477858.8810.3.camel@localhost.localdomain>
	 <47E96B0A.2010906@cs.helsinki.fi>
	 <6101e8c40803251427t777b0afdlf9e49e36b193c729@mail.gmail.com>
	 <84144f020803251438j4896d587j917fece9421a1222@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the fast answer

On 3/25/08, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Oliver,
>
> On Tue, Mar 25, 2008 at 11:27 PM, Oliver Pinter <oliver.pntr@gmail.com>
> wrote:
> >  this patch for 2.6.22?
>
> No. It fixes the following commit which is not in nor is it required for
> 2.6.22:
>
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=556a169dab38b5100df6f4a45b655dddd3db94c1
>


-- 
Thanks,
Oliver
