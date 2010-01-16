Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140Ab0APXxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0APXxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 18:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293Ab0APXxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 18:53:00 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:58892 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0APXxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 18:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=H/jmvnZ63VjUFE5z732uG6NtHKpLijqYXryPRqklAWQ7E5F2+rXYnVTUuBRgKTkTR7
         8nwpMDSrtvF0N8NhqVTAtWEzi0LJsofLEA7twkm1W9tB1xCnKc7QH33RRNjMmDIjrg4h
         7WHoDdnhfXsauSegJKTCnioHovDUOhGv1FPsQ=
MIME-Version: 1.0
Date: Sat, 16 Jan 2010 18:52:59 -0500
Message-ID: <100eff551001161552t4ff78e50vb5efa151e571349a@mail.gmail.com>
Subject: How to get the log of cfq from the userspace
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I notice there are many log infos in cfq which uses cfq_log_cfqq,
however, how can I get these logs in the userspace? I tried blktrace,
but it seems that this tool doesn't provide the info from
cfq_log_cfqq.

Thanks!

Yuehai
