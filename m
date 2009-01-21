Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZAUO42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZAUO42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbZAUO4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:56:17 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:24521 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbZAUO4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:56:16 -0500
Subject: Re: [PATCH] Btrfs: check return value for kthread_run() correctly
From: Chris Mason <chris.mason@oracle.com>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <4974aa4d.0e0d6e0a.4824.5c2b@mx.google.com>
References: <4974aa4d.0e0d6e0a.4824.5c2b@mx.google.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 09:56:07 -0500
Message-Id: <1232549767.17244.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4977378A.022A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 00:28 +0800, Qinghuang Feng wrote:
> kthread_run() returns the kthread or ERR_PTR(-ENOMEM), not NULL.
> 

Thanks, got it.

-chris


