Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYGWWjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYGWWjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYGWWjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:39:46 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:21834 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYGWWjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hPixK6sNydsL0hEoOjctPSyU3Ag47XSDRWpaDU4gdUa8Wo515/phPV58dT9l7j3Wp4
         ph83knewogi7bpRPJctNNfDYiGXxeB0m4be/8hRZnUYtnnYD+QQoTfs+zFo+ls6wY/2R
         onm+ruy5xB4XkoSJxb6Lrdr0oXVdwQZGFC/Vs=
Subject: kernel/trace/ftrace.c new warning in next-20080723
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 23 Jul 2008 15:39:45 -0700
Message-Id: <1216852786.30386.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> kernel/trace/ftrace.c: In function ‘ftrace_run_update_code’:
> kernel/trace/ftrace.c:590: warning: ‘stop_machine_run’ is deprecated (declared at include/linux/stop_machine.h:59)
> kernel/trace/ftrace.c: In function ‘ftrace_update_code’:
> kernel/trace/ftrace.c:790: warning: ‘stop_machine_run’ is deprecated (declared at include/linux/stop_machine.h:59)
> kernel/trace/ftrace.c: In function ‘ftrace_dynamic_init’:
> kernel/trace/ftrace.c:1567: warning: ‘stop_machine_run’ is deprecated (declared at include/linux/stop_machine.h:59)

FYI,

Harvey

