Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936Ab0AYUm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0AYUm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872Ab0AYUm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:42:58 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34191 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0AYUm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kTb9b9EX/KFCV72xYMVkKcuGyY+n+MC8eJqtdGqTm2iQT4RX5yr+WCZlKI/mHT5yUp
         zDsrKbsDFDs/BCJROEiQ7THrxSZo5tBf68Rqyd+jkMTQtWGukgzjSn3F2O3WXIFpFMql
         SwbVaFk2WR7Nl9wcR8LT9kTiipEEd2hbOgikA=
MIME-Version: 1.0
Date: Mon, 25 Jan 2010 15:42:55 -0500
Message-ID: <bcba51a1001251242q1478b506k92a1ac86967e1524@mail.gmail.com>
Subject: mmap a /proc/<pid>/mem file?
From: Dimitry Golubovsky <golubovsky@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Say I have a parent and a child processes. Can the parent process
access the child process memory using mmap() over /proc/<pid>/mem file
where <pid> is child's pid?

Google search returns that at some time in the past this was not
supported. Is it supported now?

Thanks

-- 
Dimitry Golubovsky

Anywhere on the Web
