Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZGCPh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZGCPh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZGCPhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:37:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbZGCPhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:37:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=QmotiNKyjVABCxH1Ii9u3Uuf4O27IONIIoWHp7jEpNF9I35s+ABRGrt719T27GL5W
	PruOfts+xr8+kvW56sMSg==
MIME-Version: 1.0
In-Reply-To: <4A4DBBC2.8010805@cn.fujitsu.com>
References: <4A4DBBC2.8010805@cn.fujitsu.com>
Date: Fri, 3 Jul 2009 08:37:14 -0700
Message-ID: <6599ad830907030837h31cdb70q9fa875d7a93b7a83@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Fix indent for /proc/cgroups
From: Paul Menage <menage@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 1:05 AM, Gui Jianfeng<guijianfeng@cn.fujitsu.com> wrote:
> Currently, /proc/cgroups outputs is fairly ugly as following,

Yes, I agree it's somewhat ugly. But it's at least very easily machine
parseable, and fairly easily human parseable, which are the important
points.

Paul
