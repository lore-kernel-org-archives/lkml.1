Return-Path: <linux-kernel-owner+w=401wt.eu-S1750763AbXBRMEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbXBRMEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXBRMEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:04:47 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:55989 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXBRMEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ASsIWtOWEl46X3hk8MMPqN6OezUKidBAOa1x9rfDqOfsvy8oQgERs7pHpSOa43m/KSHD26kq/l3uCms18+vyWKMbDvBrQ8YCXeQL64cNIRBigYhXuz6PmkJyfs4W9wMIpAmLHLFPhV1RIk2VpxsAIK54JewyCkmF/6/mzWO+9Tg=
Message-ID: <8d158e1f0702180404p1ceee9eagf8fc543544ab11ff@mail.gmail.com>
Date: Sun, 18 Feb 2007 13:04:44 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] compiling latest linus-upstream
In-Reply-To: <8d158e1f0702180402p62bb8fd3x966319be8177ee21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702180402p62bb8fd3x966319be8177ee21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> Hi all,
>
> I just tried to compile Torvald's upstream-linus and ran into a compile error.

Disregard, I ran make oldconfig again, didnt get prompted for any
configuration options, and now it does compile.


Patrick
