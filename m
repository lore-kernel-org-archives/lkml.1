Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXBJUOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXBJUOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXBJUOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:14:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:58660 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbXBJUOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:14:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OAANrct1/MGm0sAEpGI1W5FwQfyf339Vsap1TlgxSUaTYrAZc8e9Fr8z1w1LSlMcsSGLyFpuV2eEHfI14rRra4Mv0/dWMOIQQHyftrWTzP7z2tju6F6epmWpwKIzOfzs2D4xzlD0rSEwgOtXTXwQCF2U7dB3Xw4uBzn99XR8Ag0=
Message-ID: <8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>
Date: Sat, 10 Feb 2007 21:14:37 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: libsata tests started
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070210114155.6f7433c8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
	 <20070210114155.6f7433c8.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Hi,
> What are the libsata tests and where are they, please?
No where, I just compile the drivers,  see if my system boots up and
then I run some I/O intensive stuff, like bonnie++, emerge -e world at
the same time.


> So you are testing libata and ext4dev at the same time...
Not really, i dont focus on ext4dev, it just happens to be a partition
that's empty and has 40GB of space left for disk writes. I mostly use
XFS on my system.
>

> libsata == libata ?
I don't think there is a seperate libata, it's all put under libsata
if I understand the working correctly (Alan, don't sue me if I am
wrong).

Maybe it *IS* a nice idea to outline some standard tests that
developers want to have carried out or some specific tests to trace
bugs or test if a patch/fix does its work.. But that's not up to me, I
am not a coder, I can do some very basic stuff in C, that's where
programming ends for me, unless it's shell scripting.


Patrick
