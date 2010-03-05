Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0CECs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:48:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52782 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab0CECsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:48:55 -0500
Message-ID: <4B906FAA.3040808@cn.fujitsu.com>
Date: Fri, 05 Mar 2010 10:42:50 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Vivek Goyal <vgoyal@redhat.com>, jens.axboe@oracle.com,
       Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       Nauman Rafique <nauman@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2 V3] io-controller: Document for blkio.weight_device
References: <4B8DFFD7.2000908@cn.fujitsu.com> <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com> <4B906BDF.3090308@cn.fujitsu.com> <4B907006.1010309@oss.ntt.co.jp>
In-Reply-To: <4B907006.1010309@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takuya Yoshikawa wrote:
> Hi, thank you for fixing ...
> 
> Gui Jianfeng wrote:
>> +- blkio.weight_device
>> +    - One can specify per cgroup per device rules using this interface.
>> +      These rules override the default value of group weight as
>> specified
>> +      by blkio.weight.
>> +
>> +      Following is the format.
>> +
>> +      #echo dev_maj:dev_minor weight >
>> /pach/to/cgroup/blkio.weight_device
> 
> You deleted wrong character!  We need 't' not 'c'.

OOPS, Sorry :(

