Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbXKEJcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbXKEJcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 04:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbXKEJcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 04:32:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:49867 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbXKEJcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 04:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SmkuTRBlwIhudFeONg+q6OEK9OXnxyl2Y6MRC7CWc6IeUMUDhd7pfvZ4l48oA6OI++sJR933zFKAWOVJEa7SUFwNqVXeQPE2qqqLYqrNHwjDbGgzlIiTxYbVnHFGZYyTNutWO0pi9TOfsNPc7ZYn6rIPXQY/dG9rlR5okBk7nzs=
Message-ID: <35fbaa3e0711050132v7e791ab8ua4b21db144186530@mail.gmail.com>
Date: Mon, 5 Nov 2007 11:32:46 +0200
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Cc: "Pete Zaitcev" <zaitcev@redhat.com>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071104140552.GA25915@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	 <1192542889.29039.66.camel@dell1.softservecom.com>
	 <20071016154138.GA23326@1wt.eu>
	 <1192559051.29039.139.camel@dell1.softservecom.com>
	 <1192644776.10761.60.camel@dell1.softservecom.com>
	 <35fbaa3e0710190826uae4e7b7u7d8f3139e1697030@mail.gmail.com>
	 <20071019095313.76990765.zaitcev@redhat.com>
	 <1192815634.7965.53.camel@dell1.softservecom.com>
	 <20071022204539.d3e1d291.zaitcev@redhat.com>
	 <20071104140552.GA25915@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy,

On 11/4/07, Willy Tarreau <w@1wt.eu> wrote:
> I'm planning on issuing a new 2.4.36 prerelease soon. Have you made any
> progress on your code after Pete's recommendations ?

Yep. We just finalized 2.6 changes and now I'm working on 2.4 version.
Will get back to you all soon. When are you plan to make prerelease?
As always I'm too busy on my regular work and will try to put more
time to this.

Thanks,
Vitaliy
