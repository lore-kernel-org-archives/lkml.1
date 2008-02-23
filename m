Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYBWNia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYBWNia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbYBWNiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:38:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:56243 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbYBWNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:38:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E+0nkPojjCfN6ycSnBVmXOxk7PbVWfJd3JQ+Fm0BIdLcL9jVFwaoRN4Z9BQNj4qTYRavgF3dcoLmEhcnz0lE1/HNBO/OCwGKMPFbLHCgwbvH/A0LklpsqMgtozLozpgIkcQrl120YeFUdRnsOAAnmomc820PZ7kcN16/QIJIgUw=
Message-ID: <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com>
Date: Sat, 23 Feb 2008 14:38:02 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] Change a WARN message in checkpatch
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080114232913.2555d392@paolo-desktop>
	 <20080128145605.GI12910@shadowen.org>
	 <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 4:13 PM, Paolo Ciarrocchi
<paolo.ciarrocchi@gmail.com> wrote:
>
> On Jan 28, 2008 3:56 PM, Andy Whitcroft <apw@shadowen.org> wrote:
>  > On Mon, Jan 14, 2008 at 11:29:13PM +0100, Paolo Ciarrocchi wrote:
>  > > Hi Andy,
>  > > When I started using checkpatch I was confused by the following WARN message:
>  > >
>  > >       no space between function name and open parenthesis
>  > >
>  > > I thought the problem was that a space was missing while the truth is the opposite.
>  > >
>  > > How about the following patch?
>  >
>  > I can see how that language would be confusing.  Your patch makes the
>  > english clearer, but somehow seems clumsy.  There must be a better way
>  > to say this.  I will think on it and see what I can come up with.
>
>  Fair enought, I'm not English mother tongue and I'm sure you can come
>  up with a better
>  sentence :-)

AFAICS the problem is still present.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
