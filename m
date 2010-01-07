Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941Ab0AGXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0AGXG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853Ab0AGXG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:06:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0AGXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:06:56 -0500
Message-ID: <4B4668F7.1000304@zytor.com>
Date: Thu, 07 Jan 2010 15:06:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-fbdev-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] x86: allow fbdev primary video code on 64-bit.
References: <1262847894-27498-1-git-send-email-airlied@gmail.com>
In-Reply-To: <1262847894-27498-1-git-send-email-airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 11:04 PM, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> For some reason the 64-bit tree was doing this differently and
> I can't see why it would need to.
> 
> This correct behaviour when you have two GPUs plugged in and
> 32-bit put the console in one place and 64-bit in another.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Looks good... I presume this is for .34, though?

	-hpa
