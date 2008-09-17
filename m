Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYIQIpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYIQIpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYIQIpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:45:05 -0400
Received: from m12-15.163.com ([220.181.12.15]:57755 "HELO m5-85.163.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752011AbYIQIpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:45:03 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2008 04:45:03 EDT
Date: Wed, 17 Sep 2008 16:27:30 +0800
From: "Bily" <hsssss1111@163.com>
To: "mal reddy y" <malreddy.linux@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200809161515454846111@163.com>,
 <25136850809170119p2ea954ek6ece0c847dfa5823@mail.gmail.com>
Subject: Re: Re: insmod problem
Message-ID: <200809171627292035857@163.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
X-Coremail-Antispam: 1Uf129KBjvJXoWrZFW8uFW3XFy3KFWkAr4xJFb_yoW8JF1DpF
	4jqwn8tr45t3Z0yayvkw15Za4q9393Xw4fWr98Jr1fCrnFv34FvFs7Wr1YgF9xtrZIgr13
	W3ZIgr1DKa4UArJanT9S1TB71UUUUUUv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UU
	Uef7k0a2IF6r1UM7kC6x804xWl14x267AKxVWUJVW8JwAFxVCF77xC6IxKo4kEV4yl1I0E
	scIYIxCEI4klw4CSwwAFIxvE14AKwVWUJVWUGwAawVACjsI_Ar4v6c8GOVW06r1DJrWUAw
	Aa7VCY0VAaVVAqrcv_Jw1UWr13M2vYz4IE04k24VAvwVAKI4IrMc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lFcxC0V
	AYjxAxZF0Ew4CEw7xC0wACY4xI67k04243AVC20s07M4IEnf9ElVAFpTB2q-sK649IAas0
	WaI_GwAC6xAIw28IcVAK0I8IjxAxMx02cVAKzwCY02Avz4vE14v_GFylc2IjII80xcxEwV
	WxJVW3JwCF72vE52k0Y41lx4CE17CEb7AF67AKxVWUXVWUAwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UMs8CjcxG0xvEn4CqF7xvrwCE64xvF2IE
	b7IF0Fy7YxBIdaVFxhVjvjDU0xZFpf9x0zRFdgXUUUUU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m8H8jMdq012067

I am installing the linux kernel 2.6.26.2 to my AT91rm9200;I compile the kernel by using cross compiler  arm-none-eabi-gcc (Sourcery G++ Lite 2008q1-126); and the kernel can run on AT91rm9200 normally;howerver if i want to insert modules into kernel ,it happen the mistake like this:

[\u@\h \W]$insmod yaffs.ko
yaffs: unknown relocation: 40
insmod: cannot insert 'yaffs.ko': invalid module format

thanks for help!~





Bily
2008-09-17



·¢¼şÈË£º mal reddy y
·¢ËÍÊ±¼ä£º 2008-09-17 16:19:52
ÊÕ¼şÈË£º Bily
³­ËÍ£º linux-kernel
Ö÷Ìâ£º Re: insmod problem

give clear explanation how you have installed

regards,
YMR

On Tue, Sep 16, 2008 at 12:45 PM, Bily  <hsssss1111@163.com > wrote:
> hi,all;
>    I want to insert an module:yaffs.ko into my kernel2.6.26,but i meet this question:
>
> [\u@\h \W]$insmod yaffs.ko
> yaffs: unknown relocation: 40
> insmod: cannot insert 'yaffs.ko': invalid module format
>
> and my busybox version is v1.11.1; may anyone tell me why ?thanks!
>
>
> Bily
> 2008-09-13
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
