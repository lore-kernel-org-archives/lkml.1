Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbXGEWJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbXGEWJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbXGEWJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:09:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:27387 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759237AbXGEWJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=myWXeVUVLOz29lFme7O+mszP1i7tpMYaQBaR+jYaiq6RqwOLci4FdmAy9smzjShS5J9mnUSi2nzcU28S8qjLf6TOEmxXx00LA1QByv8U380xIPKGM8yx7jZS6J/P03EWf4XfncTUnAWi5tXB5XXyfa3BkO2BVPwFABIGZuUo6Zc=
Message-ID: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>
Date: Thu, 5 Jul 2007 15:09:44 -0700
From: "Gautam Singaraju" <gautam.singaraju@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: syscall macro fails upon compilation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have been adding a syscall to the kernel (v 2.6.21); I am able to
compile and boot into the kernel. However, the userspace macro fails
to compile with the following message: "error: expected declaration
specifiers or â...â before âmycallâ". I could not find any solution
using google. I use the _syscall0 macro. Any suggestion would help.
Thanks!
---
Gautam Singaraju
