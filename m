Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYJGQHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYJGQHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYJGQHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:07:33 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35304 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYJGQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:07:32 -0400
Message-ID: <48EB8912.7070407@s5r6.in-berlin.de>
Date: Tue, 07 Oct 2008 18:06:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Thiago Lacerda <thiagotbl@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Questions about mmap
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com>	 <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com>	 <48E8C8AB.3010308@s5r6.in-berlin.de>	 <3fedcc3b0810070638u60681b6do8a7e94c4919f4a40@mail.gmail.com> <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
In-Reply-To: <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Lacerda wrote:
> I'm trying to do like this:
> 
> //Code of the char device
> unsigned int **test;
> static int device_mmap(struct file *filp, struct vm_area_struct *vma) {
[...]
> could you tell me what am I doing wrong?

I can't; I never implemented a mmap file operation myself.
-- 
Stefan Richter
-=====-==--- =-=- --===
http://arcgraph.de/sr/
