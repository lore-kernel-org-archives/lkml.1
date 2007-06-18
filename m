Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbXFROpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbXFROpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762989AbXFROo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:44:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:56225 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762982AbXFROo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uc+3MqaFKllB83zaSQ2eKfDA19+QMlwU1mHtBrdN9C14INc7vWcHxO+HUbaT0czLfSzVIoc7QvNSPwVGXd9wEpo32Pge0vDPdJiaU4d0SdI96sinCe60Wa1guvOGljK5SnaacZElP+1koEHWuqX/nGD37uE8SQ+wH4kwHrbZZRA=
Message-ID: <9c21eeae0706180744v5ad9a1a3s10da42c6d6f61637@mail.gmail.com>
Date: Mon, 18 Jun 2007 07:44:56 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: "Goswin von Brederlow" <brederlo@informatik.uni-tuebingen.de>
Subject: Re: [fuse-devel] FS block count, size and seek offset?
Cc: fuse-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <87645lr69g.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0706171428u5a9ff79rad2b2083d3436d7f@mail.gmail.com>
	 <87645lr69g.fsf@informatik.uni-tuebingen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why don't you use the existing fuse-unionfs?

I thought about doing this but it would need to be modified somehow
and even then my users would look to me to fix issues and I don't like
trying to find hard bugs in other peoples code.

Also, there's a lot of functionality that funionfs has but I don't
need and the extra code would get in the way attempting to modify or
debug issues.

What I want is fairly specific and I've not seen anything out there to do it.

Thanks,
- David Brown
