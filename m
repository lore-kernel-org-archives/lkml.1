Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYEBEsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYEBEsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 00:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYEBEsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 00:48:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYEBEsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 00:48:12 -0400
Message-ID: <481A9C52.8040909@zytor.com>
Date: Thu, 01 May 2008 21:45:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: kernel/time.c: integer constant is too large for long type
References: <20080502024636.GA31465@beyonder.ift.unesp.br> <481A992D.4070807@zytor.com>
In-Reply-To: <481A992D.4070807@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Your patch is simpler, so if Linus doesn't take the patch series this 
> window we should push your patch after the window closes.
> 

Actually, your patch is actively preferable, so I'll push it to Linus 
and drop that part of the patchset.

	-hpa
