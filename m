Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZKWBB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZKWBB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZKWBB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:01:26 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60757 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZKWBB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L04e7xa60VB2f2HzyIlH+vYH89jWkaLvyufQX2y5rQb62I7M+ztMYF3UodBqEmm27w
         kpoHlbVbb+8SAN3w4uk934FACaZSSCuQM1aEqIPBwu5gdeNW4uL15ZZeDsmzZ13QIN2Q
         624gwsEO55AGaV/VOhwsyekK3VkTiAYfzFSpQ=
Message-ID: <4B09DF29.8020003@gmail.com>
Date: Mon, 23 Nov 2009 09:02:33 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5aaC5L2V6YCa6L+HZmTmib7liLDmiZPlvIDmlofku7bnmoTot68=?=
 =?UTF-8?B?5b6E5Y+K5ZCN56ew?=
References: <4B06384C.2080703@gmail.com> <20091122163700.GC3476@hack>
In-Reply-To: <20091122163700.GC3476@hack>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Fri, Nov 20, 2009 at 02:33:48PM +0800, Helight.Xu wrote:
>   
>> 在用户程序中打开文件进行编辑，那在内核中如何能通过open后的fd
>> 来找到相应打开文件的路径及其名字呢？
>>
>>     
>
> 问题是你为什么要在内核中做呢？在用户空间完全可以完成：
>
>  % readlink /proc/<PID>/fd/X
>   
我是想在内核中实现一些功能，所以现在内核中找到文件的路径及其名称，现在只 
能找到文件名，还在找路径。。。
>
>   


-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org

