Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbYBQRtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYBQRtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYBQRtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:49:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3152 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYBQRs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:48:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=udnPTgvce+11lluXrH4rJvwmrUkBpgPgKfX8mfhRF1lU8ISdcS1FDcChqx6Ky/YEu
	F3kmRFfH10NkJCfpVQGPQ==
Message-ID: <6599ad830802170948p4b39d242ubd10db541568e497@mail.gmail.com>
Date: Sun, 17 Feb 2008 09:48:56 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC][PATCH 7/7] CGroup API: Update cpusets to use cgroup structured file API
Cc: balbir@in.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080217112843.5496412d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215204418.535025000@menage.corp.google.com>
	 <20080215204821.778088000@menage.corp.google.com>
	 <20080216212901.70fe35ce.pj@sgi.com>
	 <6599ad830802170918q4c748f7fs32e5b8ea63e49f15@mail.gmail.com>
	 <20080217112843.5496412d.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 9:28 AM, Paul Jackson <pj@sgi.com> wrote:
>
> I'm figuring it would be easiest if you just threw this
> little change into your hopper for the bigger changes
> you're making

OK, will do.

Paul
