Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbZATNOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbZATNOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZATNOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:14:15 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:63888 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbZATNOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JFVeOahjF4r0m/MgYXbLNMHq8ZVg6TbDUl8UpcpZFcO7IzL6M7B5dDZmAwQ/zLAo78
         yWjyWESqHkPYosQTOWz85yEA2MkQmK7k1D3CJRxFeVuOFvPlPoiBdcWK5sftu0AXVPF1
         huzHF6/K5kY9lstHKjafQinjJ9VDZe/G+ps+U=
MIME-Version: 1.0
Date: Tue, 20 Jan 2009 08:14:13 -0500
Message-ID: <73c1f2160901200514m37cfa119r2fa5626cd505bb3@mail.gmail.com>
Subject: [PATCH 0/6] More x86 percpu cleanups
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some cleanup patches based on tj-percpu.  Now that the PDA is
gone, several headers can be merged.

--
Brian Gerst
