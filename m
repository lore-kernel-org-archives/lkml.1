Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbZLSBsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbZLSBsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 20:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbZLSBsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 20:48:22 -0500
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:63037 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937AbZLSBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 20:48:22 -0500
From: Frans Pop <elendil@planet.nl>
To: Junio C Hamano <gitster@pobox.com>
Subject: Re: Suggestion: xtime as new inode attribute
Date: Sat, 19 Dec 2009 02:48:18 +0100
User-Agent: KMail/1.9.9
Cc: poelzi@poelzi.org, linux-kernel@vger.kernel.org
References: <4B292D9A.5060501@poelzi.org> <4B292D9A.5060501@poelzi.org> <7vk4wjrf12.fsf@alter.siamese.dyndns.org>
In-reply-To: <7vk4wjrf12.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912190248.20258.elendil@planet.nl>
X-OriginalArrivalTime: 19 Dec 2009 01:48:20.0198 (UTC) FILETIME=[577AC060:01CA804D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> As I've never seen "cat /bin/sh" or similar done on an executable binary
> by sane people

How about 'strings /bin/sh' then?
Or maybe 'objdump -x /bin/sh'?
Or 'grep "something" /directory/containing/shell/scripts/*'?

But maybe I am insane.

Cheers,
FJP
