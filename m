Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbYCDIiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbYCDIiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYCDIh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:37:27 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:52841
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761149AbYCDIhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:37:25 -0500
Message-ID: <47CD0A42.9070604@qumranet.com>
Date: Tue, 04 Mar 2008 10:37:22 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: replace remaining __FUNCTION__ occurances
References: <1204577996.22933.8.camel@brick>
In-Reply-To: <1204577996.22933.8.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
>
>   
Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

