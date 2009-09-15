Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZIOOvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZIOOvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZIOOv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZIOOv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:51:26 -0400
Message-ID: <4AAFA9BC.1000409@redhat.com>
Date: Tue, 15 Sep 2009 07:50:36 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, kyle@mcmartin.ca, sct@redhat.com
Subject: Re: [PATCH] implement posix O_SYNC and O_DSYNC semantics
References: <20090915131252.GA13754@lst.de>
In-Reply-To: <20090915131252.GA13754@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2009 06:12 AM, Christoph Hellwig wrote:

> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Acked-by: Trond Myklebust<Trond.Myklebust@netapp.com>

Looks OK to me:

Acked-by: Ulrich Drepper <drepper@redhat.com>

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
