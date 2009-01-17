Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbZAQVaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbZAQVaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZAQV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:29:53 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:32992 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbZAQV3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:29:52 -0500
Subject: Re: [PATCH] Btrfs: fix bug in open_ctree()
From: Chris Mason <chris.mason@oracle.com>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <4971f34f.011e6e0a.3bb4.ffff8ae9@mx.google.com>
References: <4971f34f.011e6e0a.3bb4.ffff8ae9@mx.google.com>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 16:29:43 -0500
Message-Id: <1232227783.28343.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49724DCA.01C4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 23:03 +0800, Qinghuang Feng wrote:
> a bug in open_ctree:
> 

Thanks, this looks good.

-chris


