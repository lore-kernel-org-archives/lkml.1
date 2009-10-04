Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZJDNZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZJDNZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 09:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbZJDNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 09:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbZJDNZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 09:25:48 -0400
Message-ID: <4AC8A23A.800@redhat.com>
Date: Sun, 04 Oct 2009 15:25:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: nfs mount breakage as of 8a0382f6f
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My F11 host switched to automounting nfs v2 instead of v3.  That has 
unfortunate effects on large files.

-- 
error compiling committee.c: too many arguments to function

