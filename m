Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZDTO4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZDTO4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZDTOzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:55:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46217 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZDTOzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:55:51 -0400
Message-ID: <49EC8CF1.50207@redhat.com>
Date: Mon, 20 Apr 2009 10:55:45 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] check for frozen filesystems in the mmap path
References: <49E7C323.9040805@redhat.com>
In-Reply-To: <49E7C323.9040805@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:

> Christoph suggested maybe a check_frozen in the mmap path to
> prevent this; does the sort of thing below look sane?

Yes it does.

> signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
