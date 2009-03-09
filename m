Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZCIFsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZCIFsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 01:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZCIFsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 01:48:35 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36228 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZCIFse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 01:48:34 -0400
Date: Mon, 9 Mar 2009 06:50:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Aufs 02/25] aufs public header file
Message-ID: <20090309055030.GB14122@uranus.ravnborg.org>
References: <1236569118-3750-1-git-send-email-hooanon05@yahoo.co.jp> <1236569118-3750-3-git-send-email-hooanon05@yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236569118-3750-3-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 12:24:55PM +0900, J. R. Okajima wrote:
> initial commit
> public header file
> 
> Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> ---
>  include/linux/aufs_type.h |   98 +++++++++++++++++++++++++++++++++++++++++++++

Why does it live in include/linux?
If it is part of the userspace ABI it should be included in Kbuild.

	Sam
