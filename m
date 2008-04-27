Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbYD0ONd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbYD0ONd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 10:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYD0ONW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 10:13:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:58929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYD0ONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 10:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kxpt+TdWRWRiZpjdYpCHVxl/uefb+JiN2/YgBHu7JCYLLWwYNBm8MQJtagnkWOX21Q69a4TzB3DLSTXnSvIVwFinWw6DI50dykoNt+h7vVGMtSqX2I1nyabNkVgQWuVnZLhFilmIkgl+Z3+sn7NxvMFG5Q5WKPaFqzoJVSnIaHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fix icside breakage
Date: Sun, 27 Apr 2008 15:32:35 +0200
User-Agent: KMail/1.9.9
Cc: Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <20080427051227.GM5882@ZenIV.linux.org.uk>
In-Reply-To: <20080427051227.GM5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804271532.35594.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2008, Al Viro wrote:
> 	Fallout from commit ac95beedf8bc97b24f9540d4da9952f07221c023
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

thanks Al, applied
