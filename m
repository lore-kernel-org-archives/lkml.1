Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZAOCLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZAOCLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZAOCLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:11:06 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:29643 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZAOCLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:11:05 -0500
Subject: Re: Btrfs: remove duplicated #include
From: Chris Mason <chris.mason@oracle.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090115065753.1F16.WEIYI.HUANG@gmail.com>
References: <20090115065753.1F16.WEIYI.HUANG@gmail.com>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 21:10:54 -0500
Message-Id: <1231985454.8269.65.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.496E9B32.00F2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 06:59 +0800, Huang Weiyi wrote:
> Removed duplicated #include "compat.h"in
> fs/btrfs/extent-tree.c

Thanks, will pull these in.

-chris


