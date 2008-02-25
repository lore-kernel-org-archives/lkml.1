Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYBYTNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYBYTNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYBYTNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:13:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:52849 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbYBYTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=U5Iq6FnC/VTQsqYIRAiK09G+cZUZk+BGZiz/5qYh74nAOC4P4MokzdFPS7DATbeB7W6xlBj3EklEAE6qr14oqBt+eLiEb6KqPwxhGJR7Zdp9XxTFroMdLANUx+q7MUlLNAzhq9zGGsIaC9QXVJXgSFFjKEZrcOoCGKja5De8UkY=
Message-ID: <84144f020802251113m2cede5bbx9044ec1fc6d11f0c@mail.gmail.com>
Date: Mon, 25 Feb 2008 21:13:37 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "stephane eranian" <eranian@googlemail.com>
Subject: Re: 2.6.24 new perfmon kernel code base + libpfm + pfmon finally available!
Cc: linux-kernel@vger.kernel.org, ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <7c86c4470802250900g1eea7a26m1900c4d8ed621dfd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470802250900g1eea7a26m1900c4d8ed621dfd@mail.gmail.com>
X-Google-Sender-Auth: 188a56604b1ae763
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Mon, Feb 25, 2008 at 7:00 PM, stephane eranian
<eranian@googlemail.com> wrote:
>  I have finally released the perfmon2 kernel patch for kernel v2.6.24. It
>  took longer than expected to due my job change and several technical issues
>  related to perfmon kernel bugs.

[snip]

>  As usual all files and more detailed change logs can be downloaded
>  from our website at:
>
>        http://perfmon.sourceforge.net

Why not post the patches on LKML for review?
