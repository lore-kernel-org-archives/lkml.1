Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZA3Xdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZA3Xdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZA3Xdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:33:35 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:42512 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbZA3Xde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=sA8YyKitzw2N4zJxZEHct3c822fb8ascDb6rVng5pBXf+K7qqGvbyfccxYKvAWLsd/
         4rtviRdS0aeM4Znkd9QZrlCXU7nkV0Ed83uXDgbSv+pb9aU6rsGay81r7Ax9hLI2K5CK
         8mcJzfwk35rFtJr1c3XeatGQ3SE3D8WQb/upw=
References: <4983553A.2010804@gmail.com> <20090130225908.GB17950@uranus.ravnborg.org>
Message-Id: <BAA203A3-A9F2-4CB4-89E1-D32083572241@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20090130225908.GB17950@uranus.ravnborg.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5H11)
Mime-Version: 1.0 (iPhone Mail 5H11)
Subject: Re: headers check garble latest git
Date: Fri, 30 Jan 2009 15:33:28 -0800
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cool;

Regards;

justin P. Mattock



On Jan 30, 2009, at 2:59 PM, Sam Ravnborg <sam@ravnborg.org> wrote:

> On Fri, Jan 30, 2009 at 11:30:02AM -0800, Justin P. Mattock wrote:
>> when compiling the kernel I see lots
>> of this:
>
> Jaswinder has fixed the relvant warnings already - patchs are heading
> towards mainline. The final patch kills the check again as it turned
> out to be too agressive.
>
>    Sam
