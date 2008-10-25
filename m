Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYJYWGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYJYWGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYJYWAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:00:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbYJYWAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:00:01 -0400
Message-ID: <490396DF.4040107@zytor.com>
Date: Sat, 25 Oct 2008 14:59:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rob MacKinnon <c4blem0nkey@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: tmpfs support of xattrs?
References: <4902DD98.4090302@gmail.com>
In-Reply-To: <4902DD98.4090302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob MacKinnon wrote:
> 
> Is there sometime in the forseable future when the tmpfs module will
> support for xattrs in the stable branch, or should I "holler at the
> maintainers of coreutils to fix their broken code in cp". Even better
> (and I like this option the most) a little of both?
> 

The right answer is definitely "both".

	-hpa

