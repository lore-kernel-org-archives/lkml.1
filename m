Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZDVUwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZDVUwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZDVUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:51:59 -0400
Received: from swen.uwaterloo.ca ([129.97.92.100]:52601 "EHLO
	swen.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZDVUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:51:58 -0400
X-Greylist: delayed 1169 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 16:51:58 EDT
Message-Id: <DC736A60-0CD8-44BA-92B6-653CF56F6DB1@gsd.uwaterloo.ca>
From: Rafael Lotufo <rlotufo@swen.uwaterloo.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Tool support for Kconfig
Date: Wed, 22 Apr 2009 16:32:22 -0400
X-Mailer: Apple Mail (2.930.3)
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (swen.uwaterloo.ca [129.97.92.100]); Wed, 22 Apr 2009 16:32:28 -0400 (EDT)
X-Miltered: at mailchk-m02 with ID 49EF7EDB.001 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 30e7eaa9-b9a3-4a10-94c1-98325d68654b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My name is Rafael Lotufo, I'm a MASc student at University of Waterloo  
in the Generative Software Lab (http://gsd.uwaterloo.ca).
Our research group is currently working on tool-supported ways of  
creating feature configurations and evolving large models
of such configurations, which we refer to as feature models.

We currently see the Linux kernel configuration options as a very rich  
real-world feature model, and it has been our subject
of investigation since last January. Our current efforts have been to  
create a reasoning tool for the Kconfig options, something that
could help in finding recursive dependencies, configuration options  
that cannot be selected, and even tools that would facilitate
configuring the Linux kernel, like resolving dependencies for a wanted  
configuration option that cannot be currently selected
due to its dependencies. Furthermore, the reasoning tool can compute  
semantic diffs, intersections, unions, and slices of Kconfig
specifications.

We would be interested to receive input from interested Linux kernel  
developers regarding their experience
with modifying Kconfig files. Would a tool for analyzing and comparing  
Kconfig files be useful?
What questions one typically has to answer when evolving Kconfig  
files? Are there any frequent problems
or mistakes?

We would very much appreciate any input on this subject.

Thank you very much for you attention,

-- 
Rafael Lotufo
MASc Candidate
---------------------------------------------
Generative Software Lab
Department of Electrical & Computer Engineering
University of Waterloo
http://sites.google.com/site/rlotufouw

