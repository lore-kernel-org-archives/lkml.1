Return-Path: <linux-kernel-owner+w=401wt.eu-S1765211AbXGLMTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765211AbXGLMTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXGLMTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:19:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:23718 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbXGLMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y/uIMLcR9Vd+JjgZHREndcxA681g9BTuGB8t8jZM5/O4e5DQXQmsMbsD22Qroswzx/NJo0jyuD74oawkClMhxHxMT+SwU9USfHn9W2fO3/7bph5tKxVmg6qlDKhoS6W2e9Z3VhUflusXhhGZCiROGICvzxBrpyVBVKReG4vm3Es=
Message-ID: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com>
Date: Thu, 12 Jul 2007 15:18:42 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: NPTL
In-Reply-To: <a9e22dff0707120518q16aeae73p2905226abbadd03d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707120518q16aeae73p2905226abbadd03d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
I have a question about NPTL.
Are NPTL are still based on `clone` system call? Are NPTL threads are
"processes" internally?

Thanks!
