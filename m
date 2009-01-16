Return-Path: <linux-kernel-owner+w=401wt.eu-S935516AbZAPObr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935516AbZAPObr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZAPObe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:31:34 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:45500 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbZAPObd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:31:33 -0500
Subject: Re: [PATCH] Btrfs: simplify iteration codes
From: Chris Mason <chris.mason@oracle.com>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <49703687.044e6e0a.04fa.257b@mx.google.com>
References: <49703687.044e6e0a.04fa.257b@mx.google.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 09:31:14 -0500
Message-Id: <1232116274.21473.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49709A3F.0246:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 15:25 +0800, Qinghuang Feng wrote:
> merge list_for_each and list_entry to list_for_each_entry.
> 

Thanks, I've queued this up.

-chris


