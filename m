Return-Path: <linux-kernel-owner+w=401wt.eu-S1751504AbYE1ISZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbYE1ISZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYE1ISN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:18:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:56621 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYE1ISM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u6ik3XhfzxKPMKwTsh5V/O6g40rmZX6RScrKi/ZPQcj1x5xEFJoAdrqsjgbz7flM5ObhqhKRUMl28XKEZVZrvTlXKq16DT9wL9mNry85tI/JGoW8aPWnmf7gZ7Z0j6Sg8E7jSZgK2yuxg/7V5HAgt/oJ1ZTNbB1ulVYbYp23bQ0=
Message-ID: <3d8471ca0805280118y5e9408eeo6ec907579d4b5e89@mail.gmail.com>
Date: Wed, 28 May 2008 10:18:10 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs-writeback: handle errors in sync_sb_inodes()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080527223832.f7131761.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523203429.11846.84137.stgit@localhost.localdomain>
	 <20080527223832.f7131761.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 7:38 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> ho hum, I've forgotten why I didn't like this.

http://lkml.org/lkml/2007/1/2/238

Hope that helps :-)

-- 
Guillaume
