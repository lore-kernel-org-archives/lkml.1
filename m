Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZLAMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZLAMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZLAMN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:13:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35250 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZLAMN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ANvAcyM59L9MpK+kp02paNmhu38Z9rk/c+G7EtPcX1As4BaVZlJvbXTX+pfXeqiVLN
         4B3/LVzKy/WGD/bA9azxVvE9jVYmK9eBVL12DAO9E12NZPyKUlwLN3LHtfvKdJ2lQaxG
         5mEXKfQIXe8xMgePd3QPrdIoKKWQhMikm0KnM=
MIME-Version: 1.0
In-Reply-To: <53cc795f0911301009y786f5624v7c9f81736e0f18d8@mail.gmail.com>
References: <53cc795f0911301009y786f5624v7c9f81736e0f18d8@mail.gmail.com>
Date: Tue, 1 Dec 2009 15:14:03 +0300
Message-ID: <53cc795f0912010414p25e3e35exb652747efc4e172c@mail.gmail.com>
Subject: Re: netconsole trouble 2.6.31.6
From: sbs <gexlie@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any suggestions?


On Mon, Nov 30, 2009 at 9:09 PM, sbs <gexlie@gmail.com> wrote:
> hello
>
> I was using dynamic netconsole for some servers with kernel 2.6.31
> It worked fine and great.
>
> Yesterday I updated kernel to 2.6.31.6 and have found that there is no
> netconsole directory under /sys/kernel/config/ anymore.
>
> is that a bug or was anything changed between 2.6.31 and  2.6.31.6
> kernel about netconsole that made this directory gone away?
>
>
>
> my dynamic netconsole  kernel options:
> CONFIG_NETCONSOLE=y
> CONFIG_NETCONSOLE_DYNAMIC=y
>
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_SYSFS_DEPRECATED_V2=y
> CONFIG_ACPI_SYSFS_POWER=y
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_SYSFS=y
>
> CONFIG_CONFIGFS_FS=y
>
