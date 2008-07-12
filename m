Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYGLQUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYGLQUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 12:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYGLQUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 12:20:41 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:33157 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYGLQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 12:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nEsU9muoeZWFudwGDLcFJ3jJH+hW4dkYpCLkjrWlPqpBBGPFTtK1aE4z7Nh/jFvult
         yDJsJM5yf774DgPLSMdD7pA42ac2sN1/lUCjt6eXF//A1Zxs9EiIza3XknL1+iJ0rprX
         XKKV1Cd5Kt0fwN2PMwwzcLRgg64VElJ6uR0wM=
Message-ID: <4878D9D3.1020109@gmail.com>
Date: Sat, 12 Jul 2008 18:20:35 +0200
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: tgraf@suug.ch, johannes@sipsolutions.net
CC: linux-kernel@vger.kernel.org
Subject: genetlink: genl_unregister_mc_group
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there a special reason why genl_unregister_mc_group 
is not exported for module usage?

thanks,
Jiri Olsa
