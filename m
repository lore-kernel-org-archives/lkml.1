Return-Path: <linux-kernel-owner+w=401wt.eu-S1764201AbXJRQ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764201AbXJRQ37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbXJRQ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:29:50 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33655 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXJRQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:29:49 -0400
Message-ID: <47178A12.8080201@davidnewall.com>
Date: Fri, 19 Oct 2007 02:00:10 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: jaroslav.sykora@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
References: <200710181721.09201.jara@sin.cvut.cz>
In-Reply-To: <200710181721.09201.jara@sin.cvut.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jaroslav Sykora wrote:
> Let's say we have an archive file "hello.zip" with a hello world program source
> code. We want to do this:
> 	cat hello.zip^/hello.c
> 	gcc hello.zip^/hello.c -o hello
> 	etc..
>   

Wouldn't you do this as a user space filesystem?
