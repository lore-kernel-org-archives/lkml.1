Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbXJ2C6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbXJ2C6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXJ2C5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:57:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53593 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXJ2C5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:57:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cEQm8tW77zEEYKRgCJAERk6lOzV3BtSrINCEA+MWgbYWFldzqBDJ0KkWnpm3dTsUK
	MsFgZGpLnljlfPXfQlHVg==
Message-ID: <4d47a5d10710281957g1e423c1q6f45415d7465d90@mail.gmail.com>
Date: Sun, 28 Oct 2007 19:57:47 -0700
From: "Daniel Phillips" <phillips@google.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 1/3] VFS: apply coding standards to fs/ioctl.c
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20071028141222.GA29323@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11935266454097-git-send-email-ezk@cs.sunysb.edu>
	 <11935266451616-git-send-email-ezk@cs.sunysb.edu>
	 <20071028141222.GA29323@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/07, Christoph Hellwig <hch@infradead.org> wrote:
> While you're at it, it's probably worth splitting this out into
> a small helper function.

Why? Is the same pattern called from more than one place?

Regards,

Daniel
