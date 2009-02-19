Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZBSGDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZBSGDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZBSGDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:03:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZBSGDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:03:03 -0500
Message-ID: <499CF611.8070205@zytor.com>
Date: Wed, 18 Feb 2009 22:02:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vt_kern.h program reference
References: <499CF2F1.8050102@oracle.com>
In-Reply-To: <499CF2F1.8050102@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Does anyone know the location of this program?
> 
> from include/linux/vt_kern.h:
> 
>  * fixed.  The linux/Documentation directory includes a code snippet
>  * to save and restore the text font.
> 

You can save and restore a font via the setfont command from the kbd
package.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

