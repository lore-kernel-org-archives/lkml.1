Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbZAPPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbZAPPV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZAPPVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:21:20 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:25755 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbZAPPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:21:19 -0500
Subject: Re: [RFC][PATCH] btrfs: missing initialization while adding extent
From: Chris Mason <chris.mason@oracle.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200901132241.49268.ioe-lkml@rameria.de>
References: <200901132241.49268.ioe-lkml@rameria.de>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 10:21:10 -0500
Message-Id: <1232119270.21473.25.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4970A5E9.00CA:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 22:41 +0100, Ingo Oeser wrote:
> If we race while adding an extent and successful look it
> of afterwards, we don't set the em->bdev. Now we do :-)
> 

Thanks, queued up.

-chris


